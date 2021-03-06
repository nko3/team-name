class window.Game

    constructor : () ->

        @$view = $(ss.tmpl['game-index'].render())

        # Reset the Entire Stage
        $('body').attr 'id', ''
        $('body').attr 'class', ''
        $('body').empty()
        $('body').append @$view

        # Build out Stats Module
        @stats = new Stats()
        @stats.render()

        game_started = false
        ss.event.on 'start', (data) =>
            if game_started is false
                game_started = true
                @start_game(data)
                setTimeout (->
                    game_started = false
                ), 3000

        # Listen and assign events
        ss.event.on 'surge', (team, surge_data) =>
            console.log team.id
            console.log @da_boat.id
            if team.id == @da_boat.id
                @da_boat.move_forward()
                @stats.update(surge_data)
            
            for boat in @mini_boats
                if team.id == boat.id
                    boat.update_position(surge_data.surge)

        ss.event.on 'end', () =>
            @end_game()


    start_game : (data) ->
        @countdown()

        # Build out mini boats for preview section
        @mini_boats = []
        $('#boats').empty()
        for boat in data.teams
            if boat.id == token
                # Set the default selected boat as the first mini boat
                @da_boat = new Boat(boat)
                @da_boat.render()
                @da_boat.$view.addClass 'start'
            @mini_boats.push new MiniBoat(boat)

        # Row Call Out
        ss.event.on 'coach', () =>
            @da_boat.row_callout()


    end_game : ->
        $('#finish_line').addClass 'show'
        $('h1#row').fadeOut('fast')
        $('#checkered_flag').fadeIn('fast')

        # wave the flag
        iterator = 0
        wave_flags = setInterval (->
            $('#checkered_flag').toggleClass 'wave'
            if iterator == 5
                #clearInterval wave_flags
                #$('.boat').fadeOut('slow')
                #$('#checkered_flag').fadeOut('fast')
                window.location.reload()

            iterator++
        ), 750
        

    countdown : ->
        countdown_int = null
        $countdown  = $('#countdown')
        $line       = $('#starting_line')
        count       = 3
        
        $countdown.find('waiting').remove()
        
        # countdown timer from 3,2,1
        countit = ->
            $countdown.text count
            if count > 0
                --count
                setTimeout countit, 1000
            else
                $countdown.text 'GO'
                $countdown.toggleClass 'flashy'

                setTimeout (=>
                    $countdown.fadeOut 'fast'
                    @da_boat.$view.removeClass 'start'
                    $line.addClass 'go_away'
                    clearInterval countdown_int
                ), 1500
        
        countit()
        