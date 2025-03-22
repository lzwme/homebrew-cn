class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.9.8.tar.gz"
  sha256 "f29cce46bf3c7a718b114a6d849e2d8ff5a42e08c29a8e09d583f9fd9812fc7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60038254b926f1c67258eee138042aef64fd7abbe829a13f99e90cb65918a15f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f0893d920f1049d927891bb5ea22d0eb5fb5645e674856c94d7950cd539de84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "276d97d20ddd6a27b65fbef6b61fc91adf3ffe2396e49dd2d89da473d2ddf84a"
    sha256 cellar: :any_skip_relocation, sonoma:        "50db4404399b87f9dab31d710e1f09dd8ac85fae35ce0c1a37c7a1e4f0dbf339"
    sha256 cellar: :any_skip_relocation, ventura:       "b6c4c63302326ab55f42fa25bbe557d3679476a7f003a7370c395cf79e1e48fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5641878c907d0f3bc66ba42d0bf3be13ce0a327cab1c9e6d51398fcdbeb8d6"
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