class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://ghproxy.com/https://github.com/pgrok/pgrok/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "15bac3b6c0a100e411eee39c044218869078c2f221b59c3a911d52040412ee72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c3b7f4af2988b16e770e16894d7e3e4db091457d9c63cfe2d89a06d468bc672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c3b7f4af2988b16e770e16894d7e3e4db091457d9c63cfe2d89a06d468bc672"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c3b7f4af2988b16e770e16894d7e3e4db091457d9c63cfe2d89a06d468bc672"
    sha256 cellar: :any_skip_relocation, ventura:        "97b803912d2a71d555ca5a412d4654ca10cfea3248bbaf229f4b32f193976129"
    sha256 cellar: :any_skip_relocation, monterey:       "97b803912d2a71d555ca5a412d4654ca10cfea3248bbaf229f4b32f193976129"
    sha256 cellar: :any_skip_relocation, big_sur:        "97b803912d2a71d555ca5a412d4654ca10cfea3248bbaf229f4b32f193976129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31618cd25c95613caa4ff45812281e1aa033ef7e2a173fc61a4e98759d820cf8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    ["pgrokd", "pgrok"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f), "./cmd/#{f}"
    end

    etc.install "pgrok.example.yml"
    etc.install "pgrokd.exmaple.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    output = shell_output("#{bin}/pgrokd --config #{etc}/pgrokd.exmaple.yml 2>&1", 1)
    assert_match "[error] failed to initialize database", output

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end