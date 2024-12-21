class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.144.1",
      revision: "9a4a32328f80967c084e12af016a263673d5ec76"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e55eac4faddbcf58131a331c44459a5a50a43fdf52703283c089db1436d0ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d9ee40d23b3debb2fdce748be565ab702a96836668bb94948d612c36b83d95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c76c5a7b129a3514e3e5bb0dad4bdba4aec6d1c11bdb55ca509ae928261ff189"
    sha256 cellar: :any_skip_relocation, sonoma:        "1018ca8f309bfc590824b1f243fa4ddc71395ee72b620d93ca3d260ad28d36f7"
    sha256 cellar: :any_skip_relocation, ventura:       "b945ead5331699c687be3d85fb492dccb4d07f0fd91d6d5de1e8a765512b0333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd599c8ec10094db13484157c9117779a9b249bd0940fffd69674507ba4c0370"
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
    system bin"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end