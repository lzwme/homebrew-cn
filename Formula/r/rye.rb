class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.19.0.tar.gz"
  sha256 "ed77134449db3412b2d2ff9cc6d209acc434760f3a889683d390b5aafd8f5bc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e492558c97cbfd0c0adb43b2000c6a78d4ff60951bf97c11c1bf0c982b10d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eae6d544f3ecec63fcaa442a8248d166cff1685ccad72d564b41546334bec83a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b92321154c09ed22565dcc28d755990cf55bfd97494f454c0c12e2e53395de7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ad20ae2ab2ece942afc99ff8bb4f26901930fc0529785aa742831dc39b996c6"
    sha256 cellar: :any_skip_relocation, ventura:        "f65842426827ef4cedb3ace144ddcf5d1eb9aa2277550a5f1cd072a69fcaa9f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f4f8d83a427f7b4c2852ce2a1bd4fabc8ba386753890da90783b456a33954e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1efe28450168c10b3bd7d705d7ef56f10f10383ae3c3feb58851955b20f174"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin"rye", "self", "completion", "-s")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin"rye", "add", "requests==2.24.0"
    system bin"rye", "sync"
    assert_match "requests==2.24.0", (testpath"pyproject.toml").read
    output = shell_output("#{bin}rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end