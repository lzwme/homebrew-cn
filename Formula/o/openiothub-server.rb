class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.17",
      revision: "4b0760a8e5500db08c8c01fddb74f324266c5e4d"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "975da192218697b400190fd0532abbb46ee56d0619755ffd202521a364c2949a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975da192218697b400190fd0532abbb46ee56d0619755ffd202521a364c2949a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "975da192218697b400190fd0532abbb46ee56d0619755ffd202521a364c2949a"
    sha256 cellar: :any_skip_relocation, sonoma:        "800d87c63b1cce8a2e939be786cfa4ae929425c21124e1febf5321540e12264c"
    sha256 cellar: :any_skip_relocation, ventura:       "800d87c63b1cce8a2e939be786cfa4ae929425c21124e1febf5321540e12264c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f99b5efd15c254faafb9375c71bd8aa8f1b2717106975791f89423806e8df34"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_path_exists testpath/"server.yml"
  end
end