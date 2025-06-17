class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.18.3",
      revision: "6838ebcf265a3842d1433956e8a622e3290cf324"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43945e6a380688198cc9dece6e8d8aa252d0705084c5f2b9cdad813890ef1c0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d1070d78c63f0ea536234d37ad7a2f92d166fea53e4bd98ca3aad6ddec5b89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57ea2276bcc2eafe3e6d66779abe60be66890f98f79aaca48d1b02c7bcf4b6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe3446f9667efb3452441e9bfdbe8c06f87ba1682500bc3832f422c8ea13c34"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc16620ae358ab4d03d1c4403450ded0ca44c875d8122f59010b1bc5cddcc35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "483d7f57a6b6e1b1768c34f011409797d184973a2c92b78f3737b88078beae6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57373b2d0e69db4fb0cb622ded5a9d5e363e60b8bc73f6d348a3d4d80bc4142f"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "binhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output("#{bin}helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end