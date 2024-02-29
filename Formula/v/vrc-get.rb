class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https:github.comanatawa12vrc-get"
  url "https:github.comanatawa12vrc-getarchiverefstagsv1.7.0.tar.gz"
  sha256 "585c3efec6ff57b03ad820da5387b63af26b54b0202d4e82dbb9d977c0d0aef3"
  license "MIT"
  head "https:github.comanatawa12vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f171e6eba68591f46cc98d024ee6dfc468b7afed6e6df014eb54efe6603b8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff05cad7036a1af484addce091a815cd997e8d116472187534d0fcba1dbfe30c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dbcc45b8178cba8e70918e8b257c4dab6e2e7fb43ee805d4d216fb3a1f1b75b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab21a08e28edfb9f14e115a74433291e426deb780662da0e8d952c2754d9623b"
    sha256 cellar: :any_skip_relocation, ventura:        "f85e298accca94905cd6d644af90c634eee23409351f3ec111b65a3e06c26fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "efa475c26a3a4ae66d95e3ea7218fc4fb82afd9c09ada483a327b43dec0874ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba50c4d68431002ada2bdf217fd7979abef24cabd4c02f9aca9a64cc2ee2996"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "vrc-get")
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath"data-home"
    system bin"vrc-get", "update"
    assert_predicate testpath"data-homeVRChatCreatorCompanionReposvrc-official.json", :exist?
  end
end