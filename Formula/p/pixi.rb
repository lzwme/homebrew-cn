class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.39.5.tar.gz"
  sha256 "36e87473a8f7bf8f3169697ab5639cd4cf35eee2eb2de92265bcf2ee36b7fa43"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9a6bdfc8d9f262ff01d6dfeb41f5325ee0e17570fdf94481ba3046d2f0f78d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "098002107566f6e54c0c1328e027430ad85b96e2cb6d4c9ec9a26e3cd5785323"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43e58b221a15676734149dec7d7b40f5a4b88b8855d0268d0eae5198bbdcbd79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e03f6c5ad22ab4db235fcecad039887b74b5f8338cfe2323192bb530620752a2"
    sha256 cellar: :any_skip_relocation, ventura:       "c868c7aaca2697c8a303c768f667e01d8158d08673d5484bfb64717fae6e3bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a7f595128edfbf90557ba4ccf8c8992b7074ac57cabb3a54c2a26050ff0376"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end