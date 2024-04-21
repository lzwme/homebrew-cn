class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.42.3.tar.gz"
  sha256 "0ed6060c6e050372f0bc3d85f422dc590cf360527b7741a143a8335cec21c2a7"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a66fe6ac9c17b756a8394a3a4b20fb48bcb85f8267a35d22906ad0c343ec56c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a8a840eec61bf4b6edb53360685deb214ae0d4f40c38f0e0406da8a2430ce95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd8b6841aba9b67ae6997f9ed6cd4e7d1a8e947fa28922092c4d6bef29e31c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb6181cc62b27e9446af204101bb20641c32c3130420ffbd993bbb3a814f8f84"
    sha256 cellar: :any_skip_relocation, ventura:        "e0bfd5eb50a1c341c12888327de9eacf19d83d625d8786a909ab1a891ee92494"
    sha256 cellar: :any_skip_relocation, monterey:       "7491b68c8d0e05e90ce0db8d2c64a83ea45385f96bcd26956ab34e80be611773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bffad0d128f52c6298f60688c5c402252313587bbfcb76c1fe0fa251c6dd5f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end