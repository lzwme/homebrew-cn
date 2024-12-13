class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.8.tar.gz"
  sha256 "4baaf05c5baec6648e078f80f7660e54f6b22437e1bd80c87a072efc5cd8de91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d6443950742f7e8789a6497216583e53b101665b51712fda35d1c6a76938516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a711d67f296e6b26af96a97049c0a0190a6ec01051b623f873c3b85ba5bdba1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c6dfca79b6b4cd12a3632257bbf5742de77aecc704d241a1ab1f8bf27096735"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce9691b53d028e0f4eedeab67b0857ae0e8f2f6dd3c761492aba665df6968a18"
    sha256 cellar: :any_skip_relocation, ventura:       "978316b17f9704b83c855827bd884ff51656187d97a81a5f68ee9756e84014c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042e251824411fd4cc4cb083533eeb551120773f2cd30f9037573a45f490f071"
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