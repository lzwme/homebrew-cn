class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.16.15.tar.gz"
  sha256 "1228f31a136f3fec586da293ca717b859a5a33feee25b6abf09e3126e3a77fb8"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c17725ef7a81c2915ab360b0999ef331ab9713f6f20c8e46c58024367762183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "412d62901d7f8905c73efbd2fd4cceb371e3532e021e66d901a3421fc2e918b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92e88306e7c2f282aeb1ed5ca23f810ad6e96462ae9008bbdc8018184bc74ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf81f8ae4899bc1bd969ca8000e9fb3ce970315a265269db3e4a38be703abb96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a85f02372b854ce1727c625f3e23900e61ce4c32f1101327fc587e19ba5638"
    sha256 cellar: :any,                 x86_64_linux:  "57e8407765ce3155854f654b02238e2c3092b309bdd848d34fca4c1c81ef3dd5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end