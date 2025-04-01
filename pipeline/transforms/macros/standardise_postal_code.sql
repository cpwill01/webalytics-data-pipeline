{#
    This macro returns the postal code as a string in the standard format of the specified country.
#}

{% macro standardise_postal_code(postal_code, country_code) -%}

    case {{ country_code }}  
        when 'US' then LPAD(CAST(postal_code AS STRING), 5, '0')
        else UPPER(CAST(postal_code AS STRING))
    end

{%- endmacro %}