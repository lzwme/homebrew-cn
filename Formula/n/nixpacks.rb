class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.27.0.tar.gz"
  sha256 "5105f3d4168e4eff6c595b70f8300843034f6f3b8aa84e580e0be9eb6ba389b8"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dbce043e8951a8f71d42bc3be6d67170078ec208b42de604b23a8cb2d2b9c0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ee3704f2e4cc228b0f49bf70a385827568fcb60ee68fdcc9f8ea2f43a8b5f6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f24f85406b2f79880a1ce640f6de5cd3c2c30630f011260a4f4c8839deee60ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e3c8de5b48eb02b97f7aff8c22320a1d00495a52ad2c60475c0d8f45fd56b0c"
    sha256 cellar: :any_skip_relocation, ventura:        "5c901f66b9b82f969932b6d5a6e35e2d784b51ca6d1869352d94efb88f8fdbdf"
    sha256 cellar: :any_skip_relocation, monterey:       "ad437a7e38cbf92d48f1bf7d3b0aadd70f43fed7e95363af7705ed7edb7ee080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "736b69ada5bd82b53a5bdd3ed49c6313ecd0aad79923027c7fbf16820b99e55c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}nixpacks -V").chomp
  end
end