class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/v0.54.0.tar.gz"
  sha256 "9ca4d82baaf5b441c936f655a4d05ed8f5f0e48e99b8776a39e61884f166f97d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83d011557c7771fa61d9c02f327198a57e83d97118497cc3fa36897ea54d0540"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10769243b78c6803cd2ceafe536f64435bd76e048b9e3a0e2a9fcffbbf1dc0c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1633dfd952be0264ea2257250f3a3fdbda5adacb65291b17ee8abd259adf326a"
    sha256 cellar: :any_skip_relocation, ventura:        "a6762464ce223ba1f51bb0019a24cd22bef69129eed660126c1cbceeca0df9b7"
    sha256 cellar: :any_skip_relocation, monterey:       "be179bfe7c1065b4ee2b9553fea5dae44b28ca6747d78e3293be70fd6ad63711"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1fffa6a431179564336ebf586967b2de3eddfcb7cf7ae354517ea6154396bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd832b77d5a3743d34c83a1756c723db7c0fd4c194831d61146939e487315e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end