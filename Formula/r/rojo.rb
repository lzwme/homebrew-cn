class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https:rojo.space"
  # pull from git tag to get submodules
  url "https:github.comrojo-rbxrojo.git",
      tag:      "v7.4.2",
      revision: "844f51d91698bea8fa7483eb12e319f6afe23d87"
  license "MPL-2.0"
  head "https:github.comrojo-rbxrojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a67886be11c2cd36ff14ed4b43ece9bae32932b147ee985560d713b5d54c7ad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faebe5021337933cdf1e301f21d879f6d92ebc05b707cee83fe671222d6186a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e136766b39f271bc1f3fb95a332366194ed5bf58c4f7dd205566d79ebb73105"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c284e2030e0035a0fa2a1b51147877d5248b9777be378cb290ab374b6d6b7e6"
    sha256 cellar: :any_skip_relocation, ventura:        "fc6256ce1b090817f44605d58689f0253a497b7d5fc6fc8672fef12c6b448d54"
    sha256 cellar: :any_skip_relocation, monterey:       "0f825390489f9751115e7a70d0f5cdad2d04b33513a52228df92a96f5fc2f539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71975bbb365723b6fc257287473986b22b2e3a9e395eb269682446f0af72a635"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"rojo", "init"
    assert_predicate testpath"default.project.json", :exist?

    assert_match version.to_s, shell_output(bin"rojo --version")
  end
end