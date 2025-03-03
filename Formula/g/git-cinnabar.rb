class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https:github.comglandiumgit-cinnabar"
  url "https:github.comglandiumgit-cinnabar.git",
      tag:      "0.7.1",
      revision: "ff7d25b5900b49ae2b5df34d14d1f8ff618a481d"
  license "GPL-2.0-only"
  head "https:github.comglandiumgit-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96556af3b8cca54304dc518d29030dcde61f8fd7a6c20593ebe4db50dfcc6131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fff1deec847c334fd982db49a01b7c1b7b31e456f0a2283832392e12991f80b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51ba0623200a95ef946f80961b3019c1a7bfda3418decb3d6ef1a6b33ec6f131"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e7394a0a10d4f1c3f9a632fc94e2725c49834dd67984b6f2ad4ff6545dd9daf"
    sha256 cellar: :any_skip_relocation, ventura:       "7300928447559286b22ecc7a7ccfa337f56be2df371ba0e0cc034af6ba879be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c91ae191c4f9e28b7dc95c015ab88a7a6fabb9b292a5a062da57b4d30f39d6f1"
  end

  depends_on "rust" => :build
  depends_on "git"
  depends_on "mercurial"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin"git-cinnabar" => "git-remote-hg"
  end

  test do
    # Protocol \"https\" not supported or disabled in libcurl"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "clone", "hg::https:www.mercurial-scm.orgrepohello"
    assert_path_exists testpath"hellohello.c", "hello.c not found in cloned repo"
  end
end