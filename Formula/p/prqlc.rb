class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https:prql-lang.org"
  url "https:github.comPRQLprqlarchiverefstags0.11.0.tar.gz"
  sha256 "f82339c479a200cef681df1820433d9ac6c7bb5467ac66c8c7672299735ec075"
  license "Apache-2.0"
  head "https:github.comprqlprql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5151906d767523139f1952a799db90a8bbed7ae3c6be768f291bb2e7366ca53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d94865e2edb5dfbfbd40663a3c7e180b35888be13de64f2d25fd71e16457eaa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e7cc7c8534e43e6c309669ff6601416e7fa0de24d551ee0ff8070882ec2a43"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dd3419a4674f76ee190ea8ea32f933998fffc8788a71161bd51a236a92bea9c"
    sha256 cellar: :any_skip_relocation, ventura:        "74f5a732fd5c0c5eb3b15d8cce48a8e58015054f0d63a00b26cc3bdc49569f81"
    sha256 cellar: :any_skip_relocation, monterey:       "5ce471e5148d20790956961c42e499006a9e45b931c231006cc61def9edde889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5848f8d7fa0a261c2e6e958e3bcd2f6e24335f2858956fcc4f97adedb694c182"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlcprqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end