class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghfast.top/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "4509039d10e9d7613b7cbaac1033ae249e867fb02d88c5f9f3b119b59996d197"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ab44c6ef035a6329e758639bfdf08808d00c5b45005536ae1bf7f3a7db572b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2137e093ebb79dc3223f4b54c8d91e1e7ff55a1e78383967aa12106ec10c486a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebfba3ffe011ef436f951cc74d97cc71b2cbcdc4b4525bbfe9552e8bcc04617d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2888668753f2534591d04f335192b64225db67675207d91ac56e40d3c6eede96"
    sha256 cellar: :any_skip_relocation, ventura:       "1eee094e689bed067f24249e58be278f161c7b5c0c9af69372361831f11abb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5abd682eeac0841b0941418118bb91cda5f1a6d56277944d4c93dff76c1eb7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - failed to create backend", output
  end
end