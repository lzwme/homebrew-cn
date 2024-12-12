class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https:gittuf.dev"
  url "https:github.comgittufgittufarchiverefstagsv0.8.0.tar.gz"
  sha256 "49cb0532c3ab74b9e86ed5c4cca06dfdeb5b0f96f95c50b300020e5d82ddb2b0"
  license "Apache-2.0"
  head "https:github.comgittufgittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8fa3a3e8e47d5361384116374cb098ef3ea11aaf60a5932a1796989ba0b9bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f8fa3a3e8e47d5361384116374cb098ef3ea11aaf60a5932a1796989ba0b9bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f8fa3a3e8e47d5361384116374cb098ef3ea11aaf60a5932a1796989ba0b9bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "13739b809659c7b874c367bab41959e18214b14692a6d50cd2773d6570e96114"
    sha256 cellar: :any_skip_relocation, ventura:       "ffb3773738b16ec7112ea9c396508a1b04a4866da3b6af8c5aea737a242b4a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a7823f916f70cf0ceda45c310f93355be05f5b362aaca0e0857dfcd2667bd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comgittufgittufinternalversion.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: unable to identify GIT_DIR", output

    assert_match version.to_s, shell_output("#{bin}gittuf version")
  end
end