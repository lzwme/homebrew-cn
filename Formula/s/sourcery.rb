class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://ghproxy.com/https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.1.2.tar.gz"
  sha256 "e5716851ce7ba0b5e9b187947c725b2d810f7c88ea3f2429d0a5b5d0dabf8787"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a3b55283d36aa0f5012056d6e204d09ce10bea5982c38a7ed816ea7ef8e44f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "609d3141a2113278b3f7aa1cdec23417374d661bfcde35f050b86728b34f9ed3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a604d694265ee7a2dbb1abe8b4810326d1f4e82ae7b8fc4031cf38eb4cae4ec1"
    sha256 cellar: :any_skip_relocation, ventura:       "0dc0877c735779d7c7a858851b9c07881351e54b724ac65dfb6cd212713dae0d"
    sha256                               x86_64_linux:  "23b0f296eec79c307ff5befeeea192af4ec9b17fd2d78725caaba20b6dfaeb8e"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end