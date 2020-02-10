using Distributed
@everywhere Pkg.add("Miletus")
@info "Running jcloudmiletusdemo - updated branch!"
ENV["DRIVER_SCRIPT"] = @__FILE__
@info "Driver script ", ENV["DRIVER_SCRIPT"]

@everywhere using Miletus, DelimitedFiles, Dates, Distributed
@everywhere run(`wget -q https://externalshare.blob.core.windows.net/demos/miletus/portfolio.csv.1M`)
@everywhere p = readdlm("portfolio.csv.1M", ',', header=true)[1];

@time @distributed (vcat) for i = 1:10 # default 100
    m = CRRModel(today(), Date(p[i,3]), 250, p[i, 1], 0.1, 0.05, 0.15)
    ap = AmericanPut(Date(p[i, 3]), SingleStock(), p[i, 2])
    value(m, ap)
end
write("abc.txt", "Test")
ENV["RESULTS_FILE_TO_UPLOAD"] = "abc.txt"
@info "Results file ", ENV["RESULTS_FILE_TO_UPLOAD"]
