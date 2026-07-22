class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.40.tar.gz"
  sha256 "c34d8b3ab89771a1bde7a76155bdc5c78f401ca16481393392612a8a4f755657"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e7b773f45e78c260666db0d80ab3fe7277428a6caab30a1317fb9caf779bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086fdfcdba35bf6da08ab0c318df007ef4144f1ec50d65a6f5091fc4555fe04d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "085a7938accb2a3722fe7f76982153175029c0951c91736f89c223a953220dcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "94c540e9c8f1ad79b45ff7a4785c699fa3b8bca59cd76b5e6609ed52bc00acaa"
    sha256 cellar: :any,                 arm64_linux:   "3287271933c5016b6f1204a2dbdbd97cd706d96f048cb3eca479db9340c93883"
    sha256 cellar: :any,                 x86_64_linux:  "d5437b9d3c1ec1c963fe12ba0d08c4762ad942c6809c802a0856bba3a25dd824"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end