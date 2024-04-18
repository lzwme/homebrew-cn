class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.2.6.tar.gz"
  sha256 "77bbee5a19c5385f75f66dbb8b9399e4550b61dd2ce8dd2d9f7e1c3f3a3e0f69"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56cae3aced054e22c9acfcc6cf31d417d9dd1a6a213318422f541e2dab65e708"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd436af2bacded8bf978aaa51ae1e20d46fde4c99a23f62453296915ca778a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d6dd767734e0d0416748a9df91543655668f15eed23faf7e2b19d2e5d72337"
    sha256 cellar: :any_skip_relocation, sonoma:         "e20ef3b52a499b95fa207bc3606476c49b71dd4fe7891b1faf09b857fb04189a"
    sha256 cellar: :any_skip_relocation, ventura:        "8aef8bf8af0f5ca8f1d0a8810ad7387bfff4cc37a15830f984972bdc11e73d53"
    sha256 cellar: :any_skip_relocation, monterey:       "86f0a69f5486b63f6873841c43bd5622bd25eb5ffd7144956487d33ac583855f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3adc667f0bd4c2ae093dd87d003b632464359b0b8c51ba037761fde331cee14d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system "#{bin}runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}runme run foobar")
    assert_match "foobar", shell_output("#{bin}runme list")
  end
end