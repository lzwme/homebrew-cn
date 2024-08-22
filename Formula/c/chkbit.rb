class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https:github.comlaktakchkbit"
  url "https:github.comlaktakchkbitarchiverefstagsv5.1.2.tar.gz"
  sha256 "08b52d40a9df13d4f194d7b633c69960bf5d78279414ff064170f63dcdcb062e"
  license "MIT"
  head "https:github.comlaktakchkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee74cb4d8512ac4c70ccd4e220c1f8b0f8f2e1f469a7bb7c8bd8127c99ea484c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee74cb4d8512ac4c70ccd4e220c1f8b0f8f2e1f469a7bb7c8bd8127c99ea484c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee74cb4d8512ac4c70ccd4e220c1f8b0f8f2e1f469a7bb7c8bd8127c99ea484c"
    sha256 cellar: :any_skip_relocation, sonoma:         "effd29e77a91ed040fe3ec9618a2b799d69726d66d7af70b5f505c85f4ae9312"
    sha256 cellar: :any_skip_relocation, ventura:        "effd29e77a91ed040fe3ec9618a2b799d69726d66d7af70b5f505c85f4ae9312"
    sha256 cellar: :any_skip_relocation, monterey:       "effd29e77a91ed040fe3ec9618a2b799d69726d66d7af70b5f505c85f4ae9312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2faa4a7307b0a65e66528bee99854a3eee5477f96388b99b7c0fc92f29cd0c9c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdchkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chkbit --version").chomp

    (testpath"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin"chkbit", "-u", testpath
    assert_predicate testpath".chkbit", :exist?
  end
end