class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https:shuttle.dev"
  url "https:github.comshuttle-hqshuttlearchiverefstagsv0.56.0.tar.gz"
  sha256 "3194debf1fd1b559ef1f17a8c116813140078acc00fde5fd04310e9af33c8e67"
  license "Apache-2.0"
  head "https:github.comshuttle-hqshuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "763dbfe064d6dd5f8a929bc1cfd914881127fa80bbdc7d9f2d25d124c9d5b727"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c9f20a7f01d6b69238b268e08f0023eb4e4789059805995e9ef674581b0803"
    sha256 cellar: :any,                 arm64_ventura: "89ffad51bd43d3f5340b03eb10b4f49285830f31ba9307ddf4b4b3aac6c70932"
    sha256 cellar: :any,                 sonoma:        "18439b22a2e88f0e2d555fe7ab6570707dc78fdb7c39a99651c9606d6479e473"
    sha256 cellar: :any,                 ventura:       "449ef562d308058f69725327866e5408785256a360ba8a6c6a064ab059ea1ee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b09f7554462109bf7fb7e615198ded23bcf4841d01976c843f6ce3cd7518ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1978659707ee651218548cf6ddbcfe8c3fe85419e700cace1a93d84c0c5598"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https:github.comshuttle-hqshuttlepull1878#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(binbin_name, "generate", "shell")
      (man1"#{bin_name}.1").write Utils.safe_popen_read(binbin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}shuttle account 2>&1", 1)
    output = shell_output("#{bin}shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end