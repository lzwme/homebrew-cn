class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.9.7.tar.gz"
  sha256 "73408664cfff0737fd3d27fd22ee0daabfea885413a0fa51a5e226ac14d31733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4f0ecffc1aaac35a15aa9e82bf52b5a257f9d5485be8419d452f6c5660fd901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eaee0fe96b374dea7c933a6f846df1e04a7141403d18aba364a9ecede7ac789"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36cd9f4cff1b8e48be66bf5d47807b3897b09d240be39a3247eb7b94f4aba3d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c583cd6dc3a553d671732b8392867437322f055c20b72c021d63450f42ef09"
    sha256 cellar: :any_skip_relocation, ventura:       "e25164d25c273715b8bf970777ba24c16bbac02ca066ec65441825cfafbf2ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29fa0bbaaf1a5d085a4d3514049aaa89a607bb053c0cd6e40ed7c34c0bb3e4b4"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end