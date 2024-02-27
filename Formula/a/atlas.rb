class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.19.1.tar.gz"
  sha256 "a745be100abb0a62b7d334d86ec46f5454bf638822b290b63fa0f4172c026eed"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6303d64877880d5a5dd761a4a2c593817d2e4f29fbc9636eedbef25054bdb24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e69d45d03a57434806f58237c3e14e8219efd8397c235ac25cecb3224b64886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91d6b041ae342374f837ba55a753341cfa9cced09c7a19e8a6b8e09f719e271c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cabcfc97fd9db90656f6bd82efeb4285729e502af016e6c24be66ec45aeb457c"
    sha256 cellar: :any_skip_relocation, ventura:        "1f8137be4dca7ad406ae5079377f86e68bf2d276643f0247f626317892945e84"
    sha256 cellar: :any_skip_relocation, monterey:       "92f8e21b9f9cf05b1b5d53eb2765c1ec8ff83832ce96c3b642eff9b601504997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a678d067a0805c099f3c22ac99e020b20913484b53df7672e2169f532a580c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end