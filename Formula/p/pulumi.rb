class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.101.1",
      revision: "c48ed3ba4989cc98ce14806ccf1c57c795757388"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e71ce0bbea30cd965536ccfe63abd732e6eff3dd965a13039026793f3e4eb38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0563ff7ed24a4d4af345496ab0d858ed87f5bbe83fd1825c9408c78fa0a3c14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25dbeb78c111248dcd3f67a4dd9a3cd7e73831e923712fd1acf005f19b5860fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e6acebb0a5926988225315331cd11d4bb2173ee89d11723897da3f981305305"
    sha256 cellar: :any_skip_relocation, ventura:        "7248ca3e7fd3a33e446c25743db27e2fadc8e248977875670e1a27986fffb30d"
    sha256 cellar: :any_skip_relocation, monterey:       "c78e6c06489330524e8b26c8d6226b096c89a2096022d78b8a897393c10d1448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0283e0a3eef17c7ab4941a6f392771fdf446f3b6eab858c0f6812b4a0a368b4"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    system "#{bin}pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end