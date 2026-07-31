class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.48.tar.gz"
  sha256 "59a673b294fd3e12c5a74df5c319daa9b3e06d03804dea3fcde855dbdf3cedc1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e560fba8fd6d7bae50a3663029f996c3df23347ca7d03fbbe3e8bede862c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53844cb312fd4ccc5bf98d0efe3666f70609cef10a20799a72e89694cd32d4e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b72ef170f9ddaea5c8b558b9049dc21172ef2004cf4b67f38eec4f826aa1ce7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "62432cbc728eb389cd86130d6284149eaa43cad9fbd79217604d946438fb8288"
    sha256 cellar: :any,                 arm64_linux:   "c9e6c51549cd62050aaf2ffe7daaec07e9f1c0d369aa3dd9633b1e6d16c1a724"
    sha256 cellar: :any,                 x86_64_linux:  "08776d38a12cf9e5b605d3df1c9ce4b77bdf03a7a728ad3ae9b0f8f5aebe96ce"
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