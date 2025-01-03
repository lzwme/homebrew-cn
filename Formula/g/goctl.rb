class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https:go-zero.dev"
  url "https:github.comzeromicrogo-zeroarchiverefstagstoolsgoctlv1.7.5.tar.gz"
  sha256 "4d2271227ea63c5cce6a656dd16057022479c5c4acdf966ca0246f461bdce061"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^toolsgoctlv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "09901a91078dc39a58a2b99241b9393108e98689d96209f4867432d64a5ac931"
    sha256 cellar: :any_skip_relocation, ventura:       "09901a91078dc39a58a2b99241b9393108e98689d96209f4867432d64a5ac931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b113afd8240357f276f559ab9eaef84f42277e763bb1b68c76472ad86f6821"
  end

  depends_on "go" => :build

  # bump to use go1.23, upstream patch PR, https:github.comzeromicrogo-zeropull4279
  patch :DATA

  def install
    chdir "toolsgoctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath"#{version}#{f}"
    end
    system bin"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath"apimain.tpl", :exist?, "goctl install fail"
  end
end

__END__
diff --git atoolsgoctlgo.mod btoolsgoctlgo.mod
index 44fa301..d497f99 100644
--- atoolsgoctlgo.mod
+++ btoolsgoctlgo.mod
@@ -1,6 +1,6 @@
 module github.comzeromicrogo-zerotoolsgoctl
 
-go 1.20
+go 1.23
 
 require (
 	github.comDATA-DOGgo-sqlmock v1.5.2
diff --git atoolsgoctlgo.sum btoolsgoctlgo.sum
index e06be84..a28c6d7 100644
--- atoolsgoctlgo.sum
+++ btoolsgoctlgo.sum
@@ -9,10 +9,13 @@ github.comalicebobminiredisv2 v2.33.0go.mod h1:MhP4a3EU7aENRi9aO+tHfTBZicLqQ
 github.comantlrantlr4runtimeGoantlr v0.0.0-20210521184019-c5ad59b459ec h1:EEyRvzmpEUZ+I8WmD5cwvY8EqhambkOqy5iFr0908A=
 github.comantlrantlr4runtimeGoantlr v0.0.0-20210521184019-c5ad59b459ecgo.mod h1:F7bn7fEU90QkQ3tnmaTx3LTKLEDqnwWODIYppRQ5hnY=
 github.combenbjohnsonclock v1.1.0 h1:Q92kusRqC1XV2MjkWETPvjJVqKetz1OzxZB7mHJLju8=
+github.combenbjohnsonclock v1.1.0go.mod h1:J11hYXuz8f4ySSvYwY0FKfm+ezbsZBKZxNJlLklBHA=
 github.combeorn7perks v1.0.1 h1:VlbKKnNfV8bJzeqoa4cOKqO6bYr3WgKZxO8Z16+hsOM=
 github.combeorn7perks v1.0.1go.mod h1:G2ZrVWU2WbWT9wwq4hrbKbnv1ERSJQ0ibhJ6rlkpw=
 github.combsmginkgov2 v2.12.0 h1:Ny8MWAHyOepLGlLKYmXG4IEkioBysk6GpaRTLC8zwWs=
+github.combsmginkgov2 v2.12.0go.mod h1:SwYbGRRDovPVboqFv0tPTcG1sN61LM1Z4ARdbAV9g4c=
 github.combsmgomega v1.27.10 h1:yeMWxP2pV2fG3FgAODIY8EiRE3dy0aeFYt4l7wh6yKA=
+github.combsmgomega v1.27.10go.mod h1:JyErxRbxbtgWNi8tIEVPUYZ5Dzef52k01W3YH0H+O0=
 github.comcenkaltibackoffv4 v4.3.0 h1:MyRJUdXutAwSAT+s3wNd7MfTIcy71VQueUuFK343L8=
 github.comcenkaltibackoffv4 v4.3.0go.mod h1:Y3VNntkOUPxTVeUxJG5vcMAlwfmyYozVcomhLiZE=
 github.comcesparexxhashv2 v2.3.0 h1:UL815xU9SqsFlibzuggzjXhog7bL6oX9BbNZnL2UFvs=
@@ -52,6 +55,7 @@ github.comgo-openapiswag v0.22.4go.mod h1:UzaqsxGiab7freDnrUUra0MwWfNq7tE4j+
 github.comgo-sql-drivermysql v1.8.1 h1:LedoTUteveggdHS9qUFC1EFSa8bU2+1pZjSRpvNJ1Y=
 github.comgo-sql-drivermysql v1.8.1go.mod h1:wEBSXgmK2ZFJyE+qWnIsVGmvmEKlqwuVSjsCm7DZg=
 github.comgo-taskslim-sprig v0.0.0-20230315185526-52ccab3ef572 h1:tfuBGBXKqDEevZMzYi5KSi8KkcZtzBcTgAUUtapy0OI=
+github.comgo-taskslim-sprig v0.0.0-20230315185526-52ccab3ef572go.mod h1:9Pwr4B2jHnOSGXyyzV8ROjYa2ojvAY6HCGYYfMoC3Ls=
 github.comgodbusdbusv5 v5.0.4go.mod h1:xhWf0FNVPg57R7Z0UbKHbJfkEywrmjJnf7w5xrFpKfA=
 github.comgogoprotobuf v1.3.2 h1:Ov1cvc58UF3b5XjBnZv7+opcTcQFZebYjWzi34vdm4Q=
 github.comgogoprotobuf v1.3.2go.mod h1:P1XiOD3dCwIKUDQYPy72D8LYyHL2YPYrpS2s69NZV8Q=
@@ -68,6 +72,7 @@ github.comgooglegofuzz v1.0.0go.mod h1:dBl0BpW6vV+mYPU4Po3pmUjxk6FQPldtuIdl
 github.comgooglegofuzz v1.2.0 h1:xRy4A+RhZaiKjJ1bPfwQ8sedCA+YS2YcCHW6ec7JMi0=
 github.comgooglegofuzz v1.2.0go.mod h1:dBl0BpW6vV+mYPU4Po3pmUjxk6FQPldtuIdlM65Eg=
 github.comgooglepprof v0.0.0-20210720184732-4bb14d4b1be1 h1:K6RDEckDVWvDI9JAJYCmNdQXq6neHJOYx3V6jnqNEec=
+github.comgooglepprof v0.0.0-20210720184732-4bb14d4b1be1go.mod h1:kpwsk12EmLew5upagYY7GY0pfYCcupk39gWOCRROcvE=
 github.comgoogleuuid v1.6.0 h1:NIvaJDMOsjHA8n1jAhLSgzrAzy1Hgr+hNrb57e+94F0=
 github.comgoogleuuid v1.6.0go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEwLqOeaOT+nhxU+yHo=
 github.comgookitcolor v1.5.4 h1:FZmqs7XOyGgCAxmWyPslpiok1k05wmY3SJTytgvYFs0=
@@ -75,6 +80,7 @@ github.comgookitcolor v1.5.4go.mod h1:pZJOeOS8DM43rXbp4AZo1n9zCU2qjpcRko0b6Q
 github.comgrpc-ecosystemgrpc-gatewayv2 v2.20.0 h1:bkypFPDjIYGfCYD5mRBvpqxfYX1YCS1PXdKYWi8FsN0=
 github.comgrpc-ecosystemgrpc-gatewayv2 v2.20.0go.mod h1:P+Lt0by1T8bfcF3z737NnSbmxQAppXMRziHUxPOC8k=
 github.comh2nonparth v0.0.0-20190131123155-b4df798d6542 h1:2VTzZjLZBgl62EtslCrtky5vbi9dd7HrQPQIx6wqiw=
+github.comh2nonparth v0.0.0-20190131123155-b4df798d6542go.mod h1:Ow0tF8D4Kplbc8s8sSb3V2oUCygFHVp8gC3Dn6U4MNI=
 github.comiancolemanstrcase v0.3.0 h1:nTXanmYxhfFAMjZL34Ov6gkzEsSJZ5DbhxWjvSASxEI=
 github.comiancolemanstrcase v0.3.0go.mod h1:iwCmte+B7n89clKwxIoIXyHfoL7AsD47ZCWhYzw7ho=
 github.cominconshreveablemousetrap v1.1.0 h1:wN+x4NVGpMsO7ErUnmUI3vEoE6Jt13X2s0bqwp9tc8=
@@ -98,11 +104,13 @@ github.comklauspostcompress v1.17.9 h1:6KIumPrER1LHsvBVuDa0r5xaG0Es51mhhB9BQB2
 github.comklauspostcompress v1.17.9go.mod h1:Di0epgTjJY877eYKx5yC51cX2A2Vl2ibi7bDH9ttBbw=
 github.comkrpretty v0.2.1go.mod h1:ipqa2n7PKx3OHsz4KJII5eveXtPO4qwEXGdVfWzfnI=
 github.comkrpretty v0.3.1 h1:flRD4NNwYAUpkphVc1HcthR4KEIFJ65n8Mw5qdRn3LE=
+github.comkrpretty v0.3.1go.mod h1:hoEshYVHaxMs3cyo3Yncou5ZscifuDolrwPKZanG3xk=
 github.comkrpty v1.1.1go.mod h1:pFQYn66WHrOpPYNljwOMqo10TkYh1fy3cYio2l3bCsQ=
 github.comkrtext v0.1.0go.mod h1:4Jbv+DJW3UTLiOwJeYQe1efqtUxiVham4vfdArNI=
 github.comkrtext v0.2.0 h1:5Nx0Ya0ZqY2ygV366QzturHI13Jq95ApcVaJBhpS+AY=
 github.comkrtext v0.2.0go.mod h1:eLer722TekiGuMkidMxCpM04lWEeraHUUmBw8l2grE=
 github.comkylelemonsgodebug v1.1.0 h1:RPNrshWIDI6G2gRW9EHilWtl7Z6Sb1BR0xunSBf0SNc=
+github.comkylelemonsgodebug v1.1.0go.mod h1:90rRGxNHcop5bhtWyNeEfOS8JIWk580+fNqagVRAw=
 github.comlogrusorgruaurora v2.0.3+incompatible h1:tOpm7WcpBTn4fjmVfgpQq0EfczGlG91VSDkswnjF5A8=
 github.comlogrusorgruaurora v2.0.3+incompatiblego.mod h1:7rIyQOR62GCctdiQpZzOJlFyk6y+94wXzv6RNZgaR4=
 github.commailrueasyjson v0.7.7 h1:UGYAvKxe3sBsEDzO8ZeWOSlIQfWFlxbzLZe7hwFURr0=
@@ -120,15 +128,19 @@ github.commodern-goreflect2 v1.0.2go.mod h1:yWuevngMOJpCy52FWWMvUC8ws7mLJsjY
 github.communnerzgoautoneg v0.0.0-20191010083416-a7dc8b61c822 h1:C3w9PqII01Oq1c1nUAm88MOHcQC9l5mIlSMApZMrHA=
 github.communnerzgoautoneg v0.0.0-20191010083416-a7dc8b61c822go.mod h1:+n7T8mK8HuQTcFwEeznmDIxMOiR9yIdICNftLE1DvQ=
 github.comonsiginkgov2 v2.13.0 h1:0jY9lJquiL8fcf3M4LAXN5aMlSb2BV86HFFPCPMgE4=
+github.comonsiginkgov2 v2.13.0go.mod h1:TE309ZR8s5FsKKpuB1YAQYBzCaAfUgatBxlTETLo=
 github.comonsigomega v1.29.0 h1:KIAt2t5UBzoirT4H9tsML45GEbo3ouUnBHsCfD2tVg=
+github.comonsigomega v1.29.0go.mod h1:9sxs+SwGrKI0+PWe4Fxa9tFQQBG5xSsSbMXOI8PPpoQ=
 github.comopenzipkinzipkin-go v0.4.3 h1:9EGwpqkgnwdEIJ+Od7QVSEIH+ocmm5nPat0G7sjsSdg=
 github.comopenzipkinzipkin-go v0.4.3go.mod h1:M9wCJZFWCo2RiY+o1eBCEMe0Dp2S5LDHcMZmk3RmK7c=
 github.compelletiergo-tomlv2 v2.2.2 h1:aYUidT7k73Pcl9nb2gScu7NSrKCSHIDE89b3+6Wq+LM=
 github.compelletiergo-tomlv2 v2.2.2go.mod h1:1t835xjRzz80PqgE6HHgN2JOsmgYuh4qDAS4n929Rs=
 github.compkgerrors v0.9.1 h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=
+github.compkgerrors v0.9.1go.mod h1:bwawxfHBFNV+L2hUp1rHADufV3IMtnDRdf1r5NINEl0=
 github.compmezardgo-difflib v1.0.0 h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIkf1lZbAQM=
 github.compmezardgo-difflib v1.0.0go.mod h1:iKH77koFhYxTK1pcRnkKkqfTogsbg7gZNVY4sRDYZ4=
 github.comprashantvgostub v1.1.0 h1:BTyx3RfQjRHnUWaGF9oQos79AlQ5k8WNktv7VGvVH4g=
+github.comprashantvgostub v1.1.0go.mod h1:A5zLQHz7ieHGG7is6LLXLz7I8+3LZzsrV0P1IAHhP5U=
 github.comprometheusclient_golang v1.20.5 h1:cxppBPuYhUnsO6yoaoRol4L7q7UFfdm+bR9r+8l63Y=
 github.comprometheusclient_golang v1.20.5go.mod h1:PIEt8X02hGcP8JWbeHyeZ53YjReSnHgO035nV5WE=
 github.comprometheusclient_model v0.6.1 h1:ZKShrekM+n3CeS952MLRAdFwIKqeY8b62p8ais2e9E=
@@ -140,6 +152,7 @@ github.comprometheusprocfs v0.15.1go.mod h1:fB45yRUv8NstnjriLhBQLuOUt+WW4BsoG
 github.comredisgo-redisv9 v9.7.0 h1:HhLSs+B6O021gwzl+locl0zEDnyNkxMtfZ3NNBMa9E=
 github.comredisgo-redisv9 v9.7.0go.mod h1:f6zhXITC7JUJIlPEiBOTXxJgPLdZcA93GewI7inzyWw=
 github.comrogpeppego-internal v1.10.0 h1:TMyTOH3FDB16zRVcYyreMH6GnZZrwQVAoYjRBZyWFQ=
+github.comrogpeppego-internal v1.10.0go.mod h1:UQnix2H7Ngwk4C5ijL5+65zddjncjaFoBhdsKakog=
 github.comrussrossblackfridayv2 v2.1.0go.mod h1:+Rmxgy9KzJVeS92gXHxylqXiyQDYRxCVz55jmeOWTM=
 github.comspaolaccimurmur3 v1.1.0 h1:7c1g84S4BPRrfL5Xrdp6fOJ206sU9y293DDHaoy0bLI=
 github.comspaolaccimurmur3 v1.1.0go.mod h1:JwIasOWyU6f++ZhiEuf87xNszmSA2myDM2Kzu9HwQUA=
@@ -208,6 +221,7 @@ go.uber.orgatomic v1.10.0go.mod h1:LUxbIzbOniOlMKjJjyPfpl4v+PKK2cNJn91OQbhoJI0
 go.uber.orgautomaxprocs v1.6.0 h1:O3y2QNTOdbF+edpXNNW7Rx2hZ4sTIPyybbxyNqTUs=
 go.uber.orgautomaxprocs v1.6.0go.mod h1:ifeIMSnPZuznNm6jmdzmU3bfk01Fe2fotchwEFJ8r8=
 go.uber.orggoleak v1.3.0 h1:2K3zAYmnTNqV73imy9J1T3WC+gmCePx2hEGkimedGto=
+go.uber.orggoleak v1.3.0go.mod h1:CoHD4mav9JJNrWWLlf7HGZPjdw8EucARQHekz1X6bE=
 go.uber.orgmultierr v1.9.0 h1:7fIwcZtS0q++VgcfqFDxSBZVvXo49SYnDFupUwlI=
 go.uber.orgmultierr v1.9.0go.mod h1:X2jQV1h+kxSjClGpnseKVIxpmcjrj7MNnI0bnlfKTVQ=
 go.uber.orgzap v1.24.0 h1:FiJd5l1UOLj0wCgbSE0rwwXHzEdAZS6hiiSnxJND60=
@@ -260,6 +274,7 @@ golang.orgxtools v0.0.0-20200619180055-7c47624df98fgo.mod h1:EkVYQZoAsY45+roY
 golang.orgxtools v0.0.0-20210106214847-113979e3529ago.mod h1:emZCQorbCU4vsT4fOWvOPXz4eW1wZW4PmDk9uLelYpA=
 golang.orgxtools v0.1.1go.mod h1:o0xws9oXOQQZyjljx8fwUC0k7L1pTE6eaCbjGeHmOkk=
 golang.orgxtools v0.21.1-0.20240508182429-e35e4ccd0d2d h1:vU5iLfpvrRCpgMVPfJLg5KjxD3E+hfT1SH+d9zLwg=
+golang.orgxtools v0.21.1-0.20240508182429-e35e4ccd0d2dgo.mod h1:aiJjzUbINMkxbQROHiO6hDPo2LHcIPhhQsa9DLh0yGk=
 golang.orgxxerrors v0.0.0-20190717185122-a985d3407aa7go.mod h1:I5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
 golang.orgxxerrors v0.0.0-20191011141410-1b5146add898go.mod h1:I5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
 golang.orgxxerrors v0.0.0-20191204190536-9bdfabe68543go.mod h1:I5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
@@ -276,6 +291,7 @@ gopkg.incheck.v1 v0.0.0-20161208181325-20d25e280405go.mod h1:Co6ibVJAznAaIkqp8
 gopkg.incheck.v1 v1.0.0-20201130134442-10cb98267c6c h1:Hei4ADfdWqJk1ZMxUNpqntNwaWcugrBjAiHlqqRiVk=
 gopkg.incheck.v1 v1.0.0-20201130134442-10cb98267c6cgo.mod h1:JHkPIbrfpd72SGEVd6muEfDQjcINNoR0C8j2r3qZ4Q=
 gopkg.inh2nongock.v1 v1.1.2 h1:jBbHXgGBKAoPVfJh5x4rWxIrElvbLel8TCZkkZJoY=
+gopkg.inh2nongock.v1 v1.1.2go.mod h1:n7UGzckNChHiK05rDoiC4MYSunEClyaUm2WWaDva0=
 gopkg.ininf.v0 v0.9.1 h1:73M5CoZyi3ZLMOyDlQh031Cx6N9NDJ2Vvfl76EDAgDc=
 gopkg.ininf.v0 v0.9.1go.mod h1:cWUDdTGfYaXco+Dcufb5Vnc6Gp2YChqWtbxRZE0mXw=
 gopkg.inyaml.v2 v2.2.8go.mod h1:hI93XBmqTisBFMUTm0b8Fm+jr3Dg1NNxqwp+5A1VGuI=