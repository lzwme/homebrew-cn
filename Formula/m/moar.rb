class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.24.5.tar.gz"
  sha256 "a5531b27851a79abc6541ac1ab005e09b003e918bcd41aafdb6e33af3086816c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1da74c4c960515fe80803a6426fdfb339afb139d436b57777afe5fed1f8f10c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1da74c4c960515fe80803a6426fdfb339afb139d436b57777afe5fed1f8f10c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da74c4c960515fe80803a6426fdfb339afb139d436b57777afe5fed1f8f10c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc63ce4143eaa0eb82f1280cb2d26a10626bfcea5edb1d8376642e09b436d406"
    sha256 cellar: :any_skip_relocation, ventura:        "dc63ce4143eaa0eb82f1280cb2d26a10626bfcea5edb1d8376642e09b436d406"
    sha256 cellar: :any_skip_relocation, monterey:       "dc63ce4143eaa0eb82f1280cb2d26a10626bfcea5edb1d8376642e09b436d406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d499e441d3fb484383584028741b04c771203157e87ea011787e0501b6493994"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end