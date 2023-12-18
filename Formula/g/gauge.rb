class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.5.6.tar.gz"
  sha256 "ca5c36d3c0988c050ddeeacf7aad1d90524a6b69550221d2ac6137c80e2b01eb"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a0d75d656b2e2486dc1df107caeb49da3824841c2fd74d65816e3836b94355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e853071a0a4fdbbc55b4e18d9149d425805da7d8e76b1084c5ff3408e4ca1e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "947f7cd7c1eb7ade8fd7f5b6946078451278c5979982628459e910bf0a106367"
    sha256 cellar: :any_skip_relocation, sonoma:         "80a6a35b68b84ee5943296bcd8b4b556f371aaf7ffbb23bc65a3ff3b9a434da0"
    sha256 cellar: :any_skip_relocation, ventura:        "c2a7a40f1dd8e1d746fbd4b1cb9ff53636fd83a84a58bfaee8350d9c53395b34"
    sha256 cellar: :any_skip_relocation, monterey:       "4b287f77577156e24370c70f570ff7f40d37a331f5a5f032b2bdfc6a510de6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2244d83a7578d0e36daf5b02703e018f8d23f28e06b39748c61f624eefe0b0"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "buildmake.go"
    system "go", "run", "buildmake.go", "--install", "--prefix", prefix
  end

  test do
    (testpath"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}gauge", "install")
    assert_predicate testpath".gaugeplugins", :exist?

    system("#{bin}gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end