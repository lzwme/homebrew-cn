class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.23.3.tar.gz"
  sha256 "2dc29bdd8867877cfcf48b7160cb68fe369b12d8b95f02ef623489667b95a519"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff1a1f94b23cee7f3059a9e2797e25096e3940a7fa219c80b22b2644968d4d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02cb300cea77ae251509e96780dff50a41b619ef3f8de91f271b8fadd7c83dbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a5f62cedc3566cc7958a55f524fe122a403f3aef98b19b4671f44ec56f8991e"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e35e945002d94704aa3a0f4c2cce666021c4e25bcd4e0ed182854dd393a28a"
    sha256 cellar: :any_skip_relocation, ventura:       "ae1d3683de5d3be5136e0901d2fc188950eaa9a29655592f421bd6d62589813f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b038c428efabb0c6ef04e3102d375a71c4cc198d06cea702193cb42c9b69a917"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end