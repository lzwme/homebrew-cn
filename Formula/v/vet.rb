class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.9.tar.gz"
  sha256 "c194ecf10b701f8fea8abd799f35fc258b16500de2490a5514c0e49f1723bc22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada635540327286d3d2d495c5f77a3c208979b54eda95c0143144a02eeadfad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f83551804e22e878c2953fa413d417699ad6149839cfe052e3914d3c56ccca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a8a4252d3db3333a33cc92dd836007ad1a38cfa7ccec92d6c626192bea1ad28"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e92fcee2c8c4b59af521d35e58e3a4c69b360fa9595ce86b0873ea2da3ae10"
    sha256 cellar: :any_skip_relocation, ventura:       "d93fc184fc761ac3a8ca731df74d8f502036acc4b19af496fdcb0c75981ccdd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b040466cd405b19088b19c702b33253430a7c53db119030ee2321ad3c61fa40"
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