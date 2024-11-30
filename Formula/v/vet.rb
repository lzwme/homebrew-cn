class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.6.tar.gz"
  sha256 "a783cfbad262fa2430d5a4a8114721e25c26c6227139bf227eaa21dd9790196a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2975738e9109ce87721bfff8f0697b0193a26759a9281ef93bb270a6f79156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dfac615f886daec31ca53ce837cf9ed950e376569c8c1c34ed78b7b20a145f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c7e05c64dfa002056462ad7b4e8fe9b0c462ca17b60a99d433504c62100fdab"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b287b8a2ef7e3a0435c2fa69f48d9ffa8129115499112c50c8f07e1002cc29f"
    sha256 cellar: :any_skip_relocation, ventura:       "8ccc9c6a26e7c15ad8f1213c17d4e2cb62964bb291a09cf9bee914cc1aa4ac71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7d6cdbf3aa6c95335f21c5f8d72d770d79c60b4412cc670ef1021a839ed902"
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