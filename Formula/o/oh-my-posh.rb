class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.15.0.tar.gz"
  sha256 "988f846e77a1fc6f4afb42bbd98f9fdfc16fa9473ebbbad1fb20dd6311a257b2"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a1dc3f011be0fe9f4539ad0f689266a21fd5d8cde46a8acf4b040146b449e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833f4af48810d443fa0dd0763c5be42d2d12622f82e4ac679035596605ad516a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d101728b884b0716fd50651a89f0dd762283743c92e983d6c8875639f1b187f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3480360c1ba8c7561666134035299a01fb7912bceb0b5f3b6bc6e4ea45a56fdc"
    sha256 cellar: :any_skip_relocation, ventura:       "78d254305e25c3f867041c3502197273955b5f358154c2590471e268c78e745a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b468b3b37165ed7169f36ed974e89c44eb0bc9546662af651e20c41a7d82b4"
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