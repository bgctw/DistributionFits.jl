function test_mode_larger_than_neighbors(d)
    @testset "mode is larger than neighbors" begin
        mo = mode(d)
        @test pdf(d, mo-1e-6) < pdf(d,mo) && pdf(d, mo+1e-6) < pdf(d,mo)
    end;
end
