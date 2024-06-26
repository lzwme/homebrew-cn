class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.23.0overarch.jar"
  sha256 "2f0403aa06411e670353bad5961c45386580dffad2fdc9cf8611838eb259b6f5"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10fe588be90dfbc0040a18e828005d49f230ed7fce598f26b340db91acbf6015"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10fe588be90dfbc0040a18e828005d49f230ed7fce598f26b340db91acbf6015"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10fe588be90dfbc0040a18e828005d49f230ed7fce598f26b340db91acbf6015"
    sha256 cellar: :any_skip_relocation, sonoma:         "10fe588be90dfbc0040a18e828005d49f230ed7fce598f26b340db91acbf6015"
    sha256 cellar: :any_skip_relocation, ventura:        "10fe588be90dfbc0040a18e828005d49f230ed7fce598f26b340db91acbf6015"
    sha256 cellar: :any_skip_relocation, monterey:       "10fe588be90dfbc0040a18e828005d49f230ed7fce598f26b340db91acbf6015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f77f25a3d43e3b2c5277fbc5d2338ff3d13b042f20987d46824cfaa8f4dc8c1"
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