class Mdsh < Formula
  desc "Markdown shell pre-processor"
  homepage "https:zimbatm.github.iomdsh"
  url "https:github.comzimbatmmdsharchiverefstagsv0.9.1.tar.gz"
  sha256 "d380bb4646e272282966e152a7c3c17c71ace59c2ec1cb105327b969d1410b62"
  license "MIT"
  head "https:github.comzimbatmmdsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a48a337c5f71631cc3e47f0350f6fb4e7b865273b3b4f9346fcea38fc7415374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abed6ca16f2f5a1ab1b9f88860e14560e1f20c117ed2f17c110596662db355d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c7f79310cf30f81ee20146ad8744134e398b0ed2d184d2eb218eea183e0e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "af7bbc42f91f88a12c07c12462fc448f28cc62b74737416969941a5f25ab7983"
    sha256 cellar: :any_skip_relocation, ventura:       "356d028288a44f7652c7071789b1c70583299b848acef36c2cee54041307819f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f817e388a2c6a2509f783cc1e2174a79a685e70a8b066f694d1e4722ed5fddd"
  end

  depends_on "rust" => :build

  # version flag patch, PR: https:github.comzimbatmmdshpull80
  patch do
    url "https:github.comzimbatmmdshcommitbef17517e9176f7807f80a4f074fb7db8968a026.patch?full_index=1"
    sha256 "937aaa314e606463dee16fc7fda30aff8b981eb96e22fa7f5904e12c1ff6a907"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"README.md").write "`$ seq 4 | sort -r`"
    system bin"mdsh"
    assert_equal <<~MARKDOWN.strip, (testpath"README.md").read
      `$ seq 4 | sort -r`

      ```
      4
      3
      2
      1
      ```
    MARKDOWN

    assert_match version.to_s, shell_output("#{bin}mdsh --version")
  end
end