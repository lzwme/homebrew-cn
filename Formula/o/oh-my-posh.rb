class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.14.0.tar.gz"
  sha256 "f0159b19a9f5dc6d0228cabcc961afb63b075cc144c05b6cd4ba1a27fc07da36"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd3294b8b97c24f3371279bf9c71e11f45e8e7fb0450f677d2142f282a46d870"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1ffecf24dd21c383e1ee6bc8556e0b0fb80551ef89b46c06f85568652acddcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16f603b22a5ba1b1c0badb9de8f544fe7b98b3fc1a3b0c3b4bd9985ee02d0538"
    sha256 cellar: :any_skip_relocation, sonoma:         "59e80d439c17adb4e7c60fb98ab653c40f8715e06bb4f5b09d6c9e428f70f45a"
    sha256 cellar: :any_skip_relocation, ventura:        "c30753b403e942c0fcd4b08524d40eaebbd6f4522db22d57a876f4a3a38ab8c5"
    sha256 cellar: :any_skip_relocation, monterey:       "14d5a57d33626462ddd0337e0d0e287d93ffb4c04d035cf48f6edee29aa68b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2411061e173e57283e72a46af9f5fbb29d5ecfe52f3995d6dc0283e90d08fff9"
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
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end