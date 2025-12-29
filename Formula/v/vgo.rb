class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://ghfast.top/https://github.com/vg006/vgo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a2fee499c91225f2abe1acdb8a640560cda6f4364f4b1aff04756d8ada6282d"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49332789cd1015c1e0cc9a4178c8e258207a6579aba7d4f6275322aef8ce77e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49332789cd1015c1e0cc9a4178c8e258207a6579aba7d4f6275322aef8ce77e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49332789cd1015c1e0cc9a4178c8e258207a6579aba7d4f6275322aef8ce77e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4bc7f63a8904dd9303fa6c648e166114851f1813b6e0f2616196d09f9a22e89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c08e12409364cc439bfa6c9f936e9c18a4f6bb1e3dcb1a28e077b0f5776256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6d56ca79564aae50cd1ccacb48c3b3fecd0dd378a12a5fddaa8fc77f75e369"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vgo", shell_parameter_format: :cobra)
  end

  test do
    expected = if OS.mac?
      "Failed to build the vgo tool"
    else
      "┃ ✔ Built vgo\n┃ ✔ Installed vgo"
    end
    assert_match expected, shell_output("#{bin}/vgo build 2>&1")
  end
end