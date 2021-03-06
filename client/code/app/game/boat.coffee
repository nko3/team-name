class window.Boat

    constructor : (data) ->
        @people = data.persons
        @id     = data.id

    render : () ->

        $people = ''
        for person in @people
            $people += ss.tmpl['game-person'].render(person)

        @$view = $(ss.tmpl['game-boat'].render())
        @$view.find('.people').append $people
        @$rowCallout = @$view.find('#row')

        css_class = ''
        
        switch @people.length
            when 1 then css_class = 'two'
            when 2 then css_class = 'two'
            when 4 then css_class = 'four'
            when 6 then css_class = 'six'
            when 8 then css_class = 'eight'

        @$view.addClass css_class
        
        # remove the current boat if one exists
        current_boat = $('#watching').find('.boat')
        if current_boat.length
            current_boat.addClass 'hide'
            setTimeout (=>
                current_boat.remove()
            ), 500

        setTimeout (=>
            @$view.addClass 'show'
        ), 50

        # add it to the dom
        $('#watching').append @$view

    move_forward : ->
        @$view.find('.ore').addClass 'row'
        @$view.addClass 'row'
        setTimeout (=>
            @$view.find('.ore').removeClass 'row'
            @$view.removeClass 'row'
        ), 500

    row_callout : ->

        $('#row').removeClass 'call'
        setTimeout () =>
            $('#row').addClass 'call'
        , 1