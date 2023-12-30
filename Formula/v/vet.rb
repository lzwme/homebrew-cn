class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.5.3.tar.gz"
  sha256 "4f38a5f3efc73829fdb61fae37bb06588f468f16da2f2a371d585146a7a0e49f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ce1d47b6ebd4ed8aafd551363acbe81669ccea5395081652e8e8c7a671215a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e26b86c1f16151578c449e8ad854cd7d1148f1db4f66d57332addd552399d916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "881356f1ffcbbb5180fbc862a85d134aedd74a8695d923532ab5e55ff978d44e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c7a17b1eede1730f78caa6bd49121955e005c9ed79c3ff9357c3abdc24bf949"
    sha256 cellar: :any_skip_relocation, ventura:        "813e99cc12e1f8a3bee7a147f4b41189393c4ac56dfce1c90a728a61f9076baf"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9ac6929e49fd102ad9822ae2d9e0b1e835494bb4f7868bf1f469a701b5cc86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd3b79b0605ec75964d953bb728e015bdc216844289eea1e14fec1b79858d6b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end