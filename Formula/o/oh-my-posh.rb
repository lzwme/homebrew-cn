class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.2.1.tar.gz"
  sha256 "7147e1cfb16740ae0280447b355d59debadf17de388226a55ee955fdd6c3094a"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18d420f9fd134cf81a0604d92f922b86394653291991da36b030b92e72faf009"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75aa9e4881615a49dc073a7e4c97045520ad7ff4ee3aad7a7bb1d9228f937e7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b995aaefc88a1aa06f13686ec2fa0cb8d764fc8b2600c7cf5093a82bb7cba472"
    sha256 cellar: :any_skip_relocation, sonoma:         "c05cef42ee52936414609cbf5772c0f9b9e22e562f61311e160238b84a2dda8c"
    sha256 cellar: :any_skip_relocation, ventura:        "95948d43170c6dc0c8629c93c6225b23eae5e5b1d55d4d291f0529839f48e162"
    sha256 cellar: :any_skip_relocation, monterey:       "e4140114ebe76229b579a40bf4935230a66882a6108660a9aefe38d1947b8799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee9584c3851d214cd8dda2a62ccb8aa6d3f32b4f77f25756ee0f36822dbafc6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end