class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.28.1.tar.gz"
  sha256 "e3bf0637280070399cf65c157d9c61974c939157479b6e6aad5bb76ebfebdc9b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cffda38dadba96c5f5177359902f56b933ca78b14da8719ab32e34a4387a342f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffda38dadba96c5f5177359902f56b933ca78b14da8719ab32e34a4387a342f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cffda38dadba96c5f5177359902f56b933ca78b14da8719ab32e34a4387a342f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3dd4d75aa0c81f85727cd19aa109a6345d2523e946efb313cd9a9e259fc4142"
    sha256 cellar: :any_skip_relocation, ventura:       "d3dd4d75aa0c81f85727cd19aa109a6345d2523e946efb313cd9a9e259fc4142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "201c6ed127031218666054ec4eb77cb6a8ca5e8eed6c3bb20ffe4a0b0d004274"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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