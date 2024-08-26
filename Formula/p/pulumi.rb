class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.130.0",
      revision: "863f5ee9c699510a0d1126ec29934cec398cbc9c"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7422e0f6353f8d11fdbbbe26a12e7cecb68f50e00a349d41fcfed77b6f97290a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63dca9fe785582ba2191c03350cfde7920f447d61d2d4df21385cae074a7d458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ebec82d4db8351dd51318866f77d337b82412876dcbfd4fe41ea8fbd4675eb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "77984ba00cd641d5675d0be00f0cd921d400d9a111a9ddba7cfdcd8169a51ef6"
    sha256 cellar: :any_skip_relocation, ventura:        "cc8cf6b77be3783cd6fcd87e13df31a18086cfa12549f96359b13eb6ff5add9e"
    sha256 cellar: :any_skip_relocation, monterey:       "f47bcbc0adb4abc58e060bfbf8d95873e742379c7f6c88c2e949a66b9ed2ecca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ad3d6b946c30b93716cee25fd1d39656ed538d8ae4bdfcddb126f2e3c774d1"
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