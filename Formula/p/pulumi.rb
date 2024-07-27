class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.127.0",
      revision: "428e9efc37b50b02dba0f6277d537134ab626ba6"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40340962656dc48097964a845b32c089e348d5435c503a250afd2787082cb64c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a5ef7755be055016c8df9e0d0552c17de4f3742cbff5a43f72045f75ca55377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b6b18def43060765a093ddb56382759d7c04c5dae5066d159c441587d7d3f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ac2c81cbe08c5905d0e0b33131be3a1a08af0452a99a53c05f205393fd7000f"
    sha256 cellar: :any_skip_relocation, ventura:        "547248149619ffebe6dbb56a2ffb7b9f269f64e4485986c86239826c084dd3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ff40051cf65bd968e57816167017b64045757a6b913d8a650dc0114f9047eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f106927e931256105af395215ff466cb28fcea9cbc792762c3e7c22bf176e4e"
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