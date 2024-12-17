class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.16.4",
      revision: "7877b45b63f95635153b29a42c0c2f4273ec45ca"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f61c05a59036541ac0a3b1760ea8d9ad088b82e323810354d24cfb1e3cf22e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efe5549ee3421dab54d41fb9ccfa5c09e710be30cd95efab731aaf35cda3a9f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df79b267a94235bf470a15dbea6ad0526eefdb33d3d94792a04727321bbc98ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9f195ddc2121382d1a4c24f764c0359b761356a0c9b215dd04e149135c26a77"
    sha256 cellar: :any_skip_relocation, ventura:       "dd9273c86d745e7e83763c8a2a2fbf807e61e3060ccc22ff753ed3968ace02ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104daf1188363a96cba907696468d4d161d9620ec20d2f22b91d87580212f9f2"
  end

  depends_on "go" => :build

  # fix testchart lint errors, upstream pr ref, https:github.comhelmhelmpull13329
  patch do
    url "https:github.comhelmhelmcommitddead08eb8e7e3fbbdbb6d40938dda36905789af.patch?full_index=1"
    sha256 "471c2d7dcbd48d37eaf69e552d53e928e9ba42efccb021d78bbd354599d80811"
  end

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