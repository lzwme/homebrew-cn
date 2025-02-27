class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.9.4.tar.gz"
  sha256 "4d6b31de086a88b66d45f36353d4e67846a3ef8b85c310492b67628c17c88896"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "576406d59968e936115509000a64c35b45610b6b1bd6c456618d780458070141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7d32ab4e89108e7ad2ebe0dc95d30792ffb48a6f1496d279c9780b089d4210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da95fac4084d5a5453f3be0acc5a2f344fca975390377ab8f20cb28aa5ae1931"
    sha256 cellar: :any_skip_relocation, sonoma:        "50787f2f2beb8a920eb956435d4ccd4f0a29ee7a82e53c359747d1a6db4daf14"
    sha256 cellar: :any_skip_relocation, ventura:       "e54c6dec7bad20d761213e0f60c27d248619f04098d0f67d789a362ab5a23f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd2ade93ca9d6ebbbefc852b31764bbe0d8197b53e71a370d2dcdb97977ad2d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end