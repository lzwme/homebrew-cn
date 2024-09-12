class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:github.comignitecli"
  url "https:github.comignitecliarchiverefstagsv28.5.2.tar.gz"
  sha256 "6d7f1390c32d91b128557b7899d3ae2f8b2943f52c9f02b5bd030eb7e64de98c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4e1583c8d2c42b70919807aae2607fe1b64788cea4593a76e5e2c5a956f3f1ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78ec5a8d98dc64983f49cb4a6ab6d706f63b43a75221b675695607cf25417fc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c65e7987770b6c777cee88de82fc0b94585805fcdd5fa1700626f4f5b985c76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3008b52664039e0bc760714ceaf1901eb27ff59e8bade7ff5b8198e239a6aa7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "921a9db5d553b64d93084dc9854c741f350128ce3cec4de60afb59b472a6f558"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1165aae860bf9da758cca09c877ba32637a2b2b90234296683bde52faa0427"
    sha256 cellar: :any_skip_relocation, monterey:       "90d710f7e60cd9e1c5674d634f07efc64ef2779a79a6a3bf652418911351329f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d9220b42ffa561a18a1aa542023d88c2e3445eae3c26ed34ef2873598949e4"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath"marsgo.mod", :exist?
  end
end