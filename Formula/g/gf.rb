class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghfast.top/https://github.com/gogf/gf/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "340929e87fe7df3ff682a1fe642080db11d53a16af0527a1d17c1ca559dca6f4"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5409112239ccd630e6e0fce1fda89ada371d9d7b42657b2611b10b469e3af1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5409112239ccd630e6e0fce1fda89ada371d9d7b42657b2611b10b469e3af1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5409112239ccd630e6e0fce1fda89ada371d9d7b42657b2611b10b469e3af1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "de096d5ee58b4b7f42dc08521f53c147a932583c0288d307632561a5ab9af425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7816f0b6e871a772fc3a2deb3e86cd4818f3614b104449b5d5fcbc6ac3708927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a79ce3106a7bfb4af7add5585d0eea87abc7d93b267a03d99ea07dc329e93d"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end