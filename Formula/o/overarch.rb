class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.25.0overarch.jar"
  sha256 "8a097dd59b0d73b01881081887e80fb999160ba733e7840655d659d176d079b2"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94c201479a5a6f62ed584065ab558ffb7199c2ec46adcfeacd9e7144e80a0ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94c201479a5a6f62ed584065ab558ffb7199c2ec46adcfeacd9e7144e80a0ec8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c201479a5a6f62ed584065ab558ffb7199c2ec46adcfeacd9e7144e80a0ec8"
    sha256 cellar: :any_skip_relocation, sonoma:         "94c201479a5a6f62ed584065ab558ffb7199c2ec46adcfeacd9e7144e80a0ec8"
    sha256 cellar: :any_skip_relocation, ventura:        "94c201479a5a6f62ed584065ab558ffb7199c2ec46adcfeacd9e7144e80a0ec8"
    sha256 cellar: :any_skip_relocation, monterey:       "94c201479a5a6f62ed584065ab558ffb7199c2ec46adcfeacd9e7144e80a0ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b42cc620b3dcf681cfb57be94b89399794b7536d36fa502444d12b6ebc7d7ac"
  end

  head do
    url "https:github.comsoulspace-orgoverarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "targetoverarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec"overarch.jar", "overarch"
  end

  test do
    (testpath"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:namespaces {nil 3},
       :relations 1,
       :views-types {:container-view 1, :context-view 1},
       :external {:internal 3},
       :nodes-types {:person 1, :system 1},
       :nodes 2,
       :synthetic {:normal 3},
       :relations-types {:rel 1},
       :views 2}
    EOS
    assert_equal expected, shell_output("#{bin}overarch --model-dir=#{testpath} --model-info").chomp
  end
end