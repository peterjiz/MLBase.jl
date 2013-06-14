module MLBase

    export
        # basic_calc
        @check_argdims,
        add!, add_cols!, add_cols, add_rows!, add_rows, 
        sub!, sub_cols!, sub_cols, sub_rows!, sub_rows, 
        mul!, mul_cols!, mul_cols, mul_rows!, mul_rows,
        
        weighted_sqnorm,
        colwise_dot!, colwise_dot,
        colwise_sqnorm!, colwise_sqnorm, 
        colwise_weighted_sqnorm!, colwise_weighted_sqnorm,

        # sampling_tools
        sample_by_weights, sample_without_replacement


    # common tools

    macro check_argdims(cond)
        :( if !($(esc(cond)))
            throw(ArgumentError("Invalid argument dimensions.")) 
        end)  
    end

    # components

    include("vecarith.jl")
end
