class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.5.tar.gz"
  sha256 "66ee8a3a35e39e6fcdcea8a080c38ded69a25e8bf1a7b610ebb2f6e25b2441f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d52afc75f105c916b1787e1a23a02064778ac089dca9cc119ac16a36d54d19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d925c2af7abdd7ca5bc64027fae19fb8ee3dbe1c102e3aa858cd05ef5a843c66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b8d4d93654a0dfa515c208f4409dac2455f4c6f2a00b3b924b602c89eea533d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e436d871adaa04c08d525c6abd705062b0fb4a6fec8c8841d55656cf6f93a981"
    sha256 cellar: :any_skip_relocation, ventura:       "bd17fdc97892ffa2dfb154819bb7cda6cd9aac4670a8902118bef991ce84a8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac15840086f4d115a81212a4cfce633aceec7da1477dc06bc869c317f82fef16"
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