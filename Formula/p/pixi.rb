class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.34.0.tar.gz"
  sha256 "2e38380143ab8df1d42609cec3a37704ab5594cc4a247c56937ea9ff063d2688"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed449aa195238f660e9d62a694518e80d90f231d48cf249cbe4af9f8ffa7d999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca551166ed1864c73d843dd023690e73d10ca27776b9859e9daf33568d6a6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7ad72a427e3c572e3c6bac3f05e3dc227edc7efad084e96d967fb706ade89d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "34eb3469edf7793749febbdb4ddbdc7b1e1b859761d94e15e5834016d066e99e"
    sha256 cellar: :any_skip_relocation, ventura:       "06a16ac9040c9a189a0e44638c48573ad110a66aa4293ecea916da0c70b7d915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca39970a904fc7fadf524bd8a7ea23fddb64ede03975c401b1f3c7ceb7c2e9e7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
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