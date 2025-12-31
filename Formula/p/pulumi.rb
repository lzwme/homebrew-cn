class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.214.0",
      revision: "72adf65d22a4fb6adfe9c9824188b1cf8eb19d08"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4b0e696d949faccb368bfa45f3a78cffbeab345655c95ef5dd59338d4a8cffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526ea72f8f084e3cb12c3eed21886d87e1f436d24342b3ea9a93efae2eace5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324648adabe01c5d14bef22574c4ff83f93f24d5f66cc355077ee4260d8ea1a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "55474c8913a5598034e5fa913119354ddf42bbb5ab65ee20a43bd7394e1ce44d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9969382ed789f0cf02d3999a06cf8ca8f0109617b9269902ff59eb658061f773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4722b82bf4ea9c36b7cbc4b51285764597ff4375fc58dec242713f73f63b46cb"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end

    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end