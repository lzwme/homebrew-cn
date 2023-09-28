class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://ghproxy.com/https://github.com/tkuchiki/alp/archive/v1.0.18.tar.gz"
  sha256 "3252d44c7f23b989da15f27e7b7a67c17e47dd95a6a45ba662b0fbbb9ea0f1c3"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5134ec9924c0c426cf39ffc330b4880e8b71a036bc88ff22cc5862ac537abc93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b159580cf45b93126164ab30b38ab529c739a13c2a00cef175e6240dc85423"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e7f830a83fb19f5ca2ca82362100034d9744596acdba18c60c0ed7aa66ce61"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc2828e4f77c1951bd9417a6a99f7fb5f32817f02217dfe41dc3cd0d30a6cc9b"
    sha256 cellar: :any_skip_relocation, ventura:        "0999d550e743f9c53806a905de57d44bc85225cf126ec007359a54165d23ac65"
    sha256 cellar: :any_skip_relocation, monterey:       "2f9a8b3b105e3c5661ed0fbc3c8d814349e3983eda3db774f9a2dee3fa57da5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a06032ec85b8c4cece8b83afc9a6efdf7ca8ea015e26b59ec192a3c9a3b426d"
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