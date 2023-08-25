class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://ghproxy.com/https://github.com/tkuchiki/alp/archive/v1.0.15.tar.gz"
  sha256 "5f54fd04c39fee9b4debe5d2c3aa4abaff36da7a4e1760fc72db48fecbacf320"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c55cfee1d7044f29a3f0ae7e348152d3cb672fdd9cdff4bde92b74afe39452b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "618c165969d9dfc9b803b3f850c268a0ebc0e3ed35a3f30753b74822eca69b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f5a7cafb8ef97dcb8ad30209660411ab1978a348ff10537c0d180481a6aad94"
    sha256 cellar: :any_skip_relocation, ventura:        "b7f97416f121ae7dcd644edfd4d03cb5fbb4ec65ee8bed3827e3b3adaff7da7f"
    sha256 cellar: :any_skip_relocation, monterey:       "cd56644269d6d4dd568bb359b422721e2976058484f8eaee68c6ed5dfdfdfd34"
    sha256 cellar: :any_skip_relocation, big_sur:        "da2db89ecd360bc17f3c8bef11af6cb9d75a2f2c027eff3555ce5c9e1006e0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4320e91680c1809b7f3050ab0147ce59d5647c46cae8fb5cbae0deac50912b40"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/alp"

    generate_completions_from_executable(bin/"alp", "completion")
  end

  test do
    (testpath/"json_access.log").write <<~EOS
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"/foo/bar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"/foo/bar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"/hoge/piyo?id=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"/foo/bar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"/foo/bar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/diary/entry/1234","status":200,"body_bytes":15,"response_time":0.135}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/diary/entry/5678","status":200,"body_bytes":30,"response_time":0.432}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar/5xx","status":504,"body_bytes":15,"response_time":60.000}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/req","status":200,"body_bytes":15,"response_time":"-", "request_time":0.321}
    EOS
    system "#{bin}/alp", "json", "--file=#{testpath}/json_access.log", "--dump=#{testpath}/dump.yml"
    assert_predicate testpath/"dump.yml", :exist?
  end
end